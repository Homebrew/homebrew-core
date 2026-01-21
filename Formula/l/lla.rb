class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2c97e025b2dad945dfa5f62fcc92a530ed04942b34332cdb08da91a2d5ceb5aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b87b45a39840973f301a81606df73ab7e9eaa12680891d0adf2dc0a28fc09c2"
    sha256 cellar: :any,                 arm64_sequoia: "71c11b72105b73200ce45449154e8fe1fb73a6b31df41ffbe812db20b4168808"
    sha256 cellar: :any,                 arm64_sonoma:  "5ff4906b987507ece45ce995cdd7ad20e4001007b31db39526f6ff8f3117584d"
    sha256 cellar: :any,                 sonoma:        "1d0973de4d55435516bdffa0bd9bbcb9e0282842f0a3e65154cb0535f79aece3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbae99fac6089606de94e4a902c9f52e34aba7275f19f6a6e9637a5bb4ab2f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390c1a55bf4068e3c862026b8fd95e39d91fcc57ebb4340e1c45bfde53e18872"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

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
