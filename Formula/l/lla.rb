class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "4a5918143952f774019996e67799e690765ccfee92b269c45e6f491390ee280b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7be0df7dcf009d684273188e636d7f5ee0dcbbc3f42777d9f53b3d847ba20ea4"
    sha256 cellar: :any,                 arm64_sequoia: "8defe6c9945740e10709a0dd2f7f759a6d9c788b763ff5274ecaf5cf6f03c644"
    sha256 cellar: :any,                 arm64_sonoma:  "bc19d860cbcaeaf8a34c9d0ccdb09835acfe287056688abb77dc9c72c08a239c"
    sha256 cellar: :any,                 sonoma:        "cc0d6442c913d20e8b93b602841e790e4a57fbe00de52a0056e7f875f4a36670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dabfbeb93dda2dd235dbffe4313d43593cda58c18d6f6a7958bad323118114c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11f4a4ee1dcbf623a0e6e153c935422194a9a5aa79fadfdf24a8658c37e214b"
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
