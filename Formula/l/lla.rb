class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "578bd6d4e89044988d140962c47a9618c74f101cb861802a9ab8cc2a708833d5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "50463d767785c6cbd3af4430268acb6e6c28dd43fd2b817a7803436d6f9ba402"
    sha256 cellar: :any, arm64_tahoe:       "b8c0b27891bc785285c325a1cc9faf3aacae63015743fd6f6a7071be513b3c0f"
    sha256 cellar: :any, arm64_sequoia:     "acce00eef63e47d21ce89c3134dc9c854ad6d4ae709ad6c10457c4a643c68455"
    sha256 cellar: :any, arm64_linux:       "546b08439a088691f59daff4e2f6fec9c2b66ca7ada7786aef936eb414bc0a77"
    sha256 cellar: :any, x86_64_linux:      "235f4058da9441ffba033c9aac084d011d1c46f6f1b72878cf765ae0b20ce529"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    generate_completions_from_executable(bin/"lla", "completion")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
