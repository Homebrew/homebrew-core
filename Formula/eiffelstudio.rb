class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/19.05/eiffelstudio-19.05.10.3187.tar"
  sha256 "b5f883353405eb9ce834c50a863b3721b21c35950a226103e6d01d0101a932b3"

  bottle do
    cellar :any
    sha256 "8a7764d27dccc50a8bd8d34175591c90bd52ef8c3e3bf256a941cfccbd0e7f84" => :mojave
    sha256 "1204b20cd8146aeb89dc15b904ee792cfe6dd7141bc30536beba436efa667cea" => :high_sierra
    sha256 "4f8f7374ec1a2032334dd13ddf00d93b3feda22c75d884f7c0f8fe799f27643b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./compile_exes", "macosx-x86-64"
    system "./make_images", "macosx-x86-64"
    prefix.install Dir["Eiffel_19.05/*"]
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
