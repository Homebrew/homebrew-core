class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/18.11/eiffelstudio-18.11.10.2592.tar"
  sha256 "9ee3c9663e21123a84e1447e301919171c2939b117ed1ad5780ba3e8021204ef"

  bottle do
    cellar :any
    sha256 "1d10a333b4a0c02bcb3349c0e08cc098044c910f41918d568ef64abf3a60c56e" => :mojave
    sha256 "b8b9e63265767087d299fca6947226e01b619dcb675921736dba47e44422b783" => :high_sierra
    sha256 "da85e81c76e071da3642ad3fa7f01414c5485cbea3320a2ec4081358dd0b9e05" => :sierra
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
