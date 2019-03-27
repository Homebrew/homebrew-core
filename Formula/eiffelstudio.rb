class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/18.11/eiffelstudio-18.11.10.2592.tar"
  sha256 "9ee3c9663e21123a84e1447e301919171c2939b117ed1ad5780ba3e8021204ef"

  bottle do
    cellar :any
    sha256 "dd72c10b3b814fd0a5f2658f24b9959f216fd1aab9ee0e52f5105c4803362259" => :mojave
    sha256 "7b03fd689acdc6a9b477eb569f6438fb8648c43cd79b87fe1a25db1d96bc8d76" => :high_sierra
    sha256 "8e2cb58f4954fb7e1906d4ad62865d1104509d3ae303d6e4f5021f3225726727" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./compile_exes", "macosx-x86-64"
    system "./make_images", "macosx-x86-64"
    prefix.install Dir["Eiffel_18.11/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :ISE_PLATFORM => "macosx-x86-64" }
    (bin/"ec").write_env_script(prefix/"studio/spec/macosx-x86-64/bin/ec", env)
    (bin/"ecb").write_env_script(prefix/"studio/spec/macosx-x86-64/bin/ecb", env)
    (bin/"estudio").write_env_script(prefix/"studio/spec/macosx-x86-64/bin/estudio", env)
    (bin/"finish_freezing").write_env_script(prefix/"studio/spec/macosx-x86-64/bin/finish_freezing", env)
    (bin/"compile_all").write_env_script(prefix/"tools/spec/macosx-x86-64/bin/compile_all", env)
    (bin/"iron").write_env_script(prefix/"tools/spec/macosx-x86-64/bin/iron", env)
    (bin/"syntax_updater").write_env_script(prefix/"tools/spec/macosx-x86-64/bin/syntax_updater", env)
    (bin/"vision2_demo").write_env_script(prefix/"vision2_demo/spec/macosx-x86-64/bin/vision2_demo", env)
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
