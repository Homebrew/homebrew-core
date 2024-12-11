class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/triyanox/lla"
  url "https://github.com/triyanox/lla/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "52b75480f2b83e9c03ba47c768399ed867944ae9795bfd2f7903c634618f04af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2fc32e5f17c2080f83c6ae40c592e1013dbfe688308907e94f1027fe60e3f790"
    sha256 cellar: :any,                 arm64_sonoma:  "df3fd22eb7927d287680ab0f28a697a699ff06f46bdd2c1a0fc2eb87d50f8cc4"
    sha256 cellar: :any,                 arm64_ventura: "993b65cfc2d0972f831327c501f8b654ebbe2bd7e5495ed0c4c48997f7f82a6a"
    sha256 cellar: :any,                 sonoma:        "72532a59d840e4d9e42cfd64d18e4bcb68c428e98d67fa39289b569c4f94e3ff"
    sha256 cellar: :any,                 ventura:       "73ecd6feb44b828df32d9678f4bc0c29136ce431d5888c3cebff698752a6c2c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0949461f42ce1dfe90b77412ad3b2b0d459de9b34dbe3054e864c5c3751041c"
  end

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

    system bin/"lla", "init"

    output = shell_output("#{bin}/lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
