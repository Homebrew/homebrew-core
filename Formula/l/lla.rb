class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/triyanox/lla"
  url "https://github.com/triyanox/lla/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "d6ffe717e8f18223361d559b7d46889d079287d19fa78bccb9350f4c0491b7e5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45d6e9ca977c48ae137b349bd42e2d8a0caf878884e5a75839f72c70f1bde4de"
    sha256 cellar: :any,                 arm64_sonoma:  "02242f3c08f8dda0b0eac3a876acc7c8aedb028917397627eb3510a304feaabb"
    sha256 cellar: :any,                 arm64_ventura: "030d1a6297c8599e9de1828e343cb792f304e938b4e261bfcb154f6dd8cd7f3c"
    sha256 cellar: :any,                 sonoma:        "4c5be9f37e5eb657e16bf9054906eb59fac5b0946fba9784bcce94a504accb4b"
    sha256 cellar: :any,                 ventura:       "dba5cea0b6eecb3e28a27bb019a29aa4dc6547ddaf3b32d07eb0486c9c58249c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6859f5598b2cbd26a33b84881b20bcaa4f703b5ed8d9a2872fa1b010249c585"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # patch to support for setting plugins_dir in config, upstream pr ref, https://github.com/triyanox/lla/pull/55
  patch do
    url "https://github.com/triyanox/lla/commit/d62ff45712af524637373e6b69291e6d07d451bd.patch?full_index=1"
    sha256 "bb41d0bfce43003f40a3db955436feac5b96733f1acabcbad47783f93fe66436"
  end

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
