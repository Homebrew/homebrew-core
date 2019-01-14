class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/17.01/eiffelstudio-17.01.9.9700.tar"
  sha256 "610344e8e4bbb4b8ccedc22e57b6ffa6b8fd7b9ffee05edad15fc1aa2b1259a1"
  revision 1

  bottle do
    cellar :any
    sha256 "7eb94341135ce70e41603fa25bfd42f098d61bc49d465b098691b0a207b1a79b" => :mojave
    sha256 "f491bb0dca20ea532084e78b82319111cfc5d981a10edf53ff20109d75772b79" => :high_sierra
    sha256 "27e2c1b87f4b191003c8bc4b8fc205495efe22207634967555cc87b64a39cf39" => :sierra
    sha256 "989ed927f5438496827a9d1a1e068773b4f5f543d6d6f0374b1520449fa3aafb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./compile_exes", "macosx-x86-64"
    system "./make_images", "macosx-x86-64"
    prefix.install Dir["Eiffel_17.01/*"]
    bin.mkpath
    env = { :ISE_EIFFEL => prefix, :"macosx-x86-64" => "macosx-x86-64" }
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
    system prefix/"studio/spec/macosx-x86-64/bin/ec", "-version"
  end
end
