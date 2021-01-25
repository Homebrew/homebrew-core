class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/v0.7.1.tar.gz"
  sha256 "cb7167ee8770d2903839e00d4a631cca08fb8095b2339c8796e7b9510d5f5055"
  license "MPL-2.0"
  head "https://github.com/mozilla/grcov.git"

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    rustflags = "-Zprofile -Ccodegen-units=1 -Copt-level=0 -Clink-dead-code -Coverflow-checks=off -Zpanic_abort_tests"
    env = {
      CARGO_INCREMENTAL: "0",
      RUSTC_BOOTSTRAP:   "1",
      RUSTFLAGS:         rustflags,
      RUSTDOCFLAGS:      "-Cpanic=abort",
    }
    system "cargo", "new", "hello_world", "--bin"
    cd testpath/"hello_world" do
      with_env(env) do
        system "cargo", "test"
      end
      system bin/"grcov", ".", "-t", "html"
      assert_predicate testpath/"hello_world/html/index.html", :exist?
    end
  end
end
