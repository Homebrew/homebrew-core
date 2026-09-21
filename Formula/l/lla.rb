class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "f4d4be9b797dc6bd7ef49cbb65c573f3e72700614e77ebc90204980ee9328fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a811f9718eb2bf2fdc5e43e68c40cbcc38cf74d125eaf9a42183d3152411a9e7"
    sha256 cellar: :any, arm64_tahoe:       "a691c55b2685f1c7324b635164d6821ea20b935573447a5b70a48631734de9cf"
    sha256 cellar: :any, arm64_sequoia:     "62f0ad14653e1ff4a2eb3b8a2c7d12a8a65671733f19f380d9003b2ba51474c6"
    sha256 cellar: :any, arm64_linux:       "b7a420db590c8ce3912ebacf91a74f4c709b32a29ec7597c1bcea9a417e0df8f"
    sha256 cellar: :any, x86_64_linux:      "098d601dc50e63b31480aeb3549fe670d8b20ad3fa4a28db45daf552edcfadc0"
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
