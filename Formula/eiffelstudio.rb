class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/19.05/eiffelstudio-19.05.10.3187.tar"
  sha256 "b5f883353405eb9ce834c50a863b3721b21c35950a226103e6d01d0101a932b3"

  bottle do
    cellar :any
    sha256 "28b738ce36b616c1480309841aa04db4dd052223adf0fb86e218efe9aa9e835c" => :mojave
    sha256 "4ca7f35feed76bb3c3c64a18c3aea0ac82087ce2022220faa921a5d310fb0410" => :high_sierra
    sha256 "fe019f342cd9bc955afb00fbf87a8d2a78962829682f5bcd9f100efcc020a58d" => :sierra
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
