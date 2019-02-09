class KimApiV2 < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-v2-2.0.1.txz"
  sha256 "6b54a9c4bc34c669b8ef00b9be4bbdce6fca2bb813dc1fe7697d618f267860d0"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  def install
    args = std_cmake_args
    # needs to think it is installed in #{HOMEBREW_PREFIX}
    args << "-DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}"
    # needs to be able to find libexec executables within #{HOMEBREW_PREFIX}
    args << "-DCMAKE_INSTALL_LIBEXECDIR=#{HOMEBREW_PREFIX}/lib"
    # adjust compiler settings for package
    args << "-DKIM_API_CMAKE_C_COMPILER=/usr/bin/clang"
    args << "-DKIM_API_CMAKE_CXX_COMPILER=/usr/bin/clang++"
    system "cmake", ".", *args
    system "make"
    system "make", "docs"
    # Install to #{prefix}#{HOMEBREW_PREFIX}
    system "make", "DESTDIR=#{prefix}", "install"
    # Move things around to match homebrew's expectations.
    move Dir.glob("#{prefix}#{HOMEBREW_PREFIX}/*"), prefix.to_s
    rm_rf "#{prefix}#{HOMEBREW_PREFIX}"
    #
    # The above process seems to be the only way to have the package work as
    # expected when installed with homebrew. (The package looks for shared
    # libraries in "#{lib}".  Other packages will install shared libraries to
    # "#{lib}", but this is not allowed by homebrew.)
  end

  test do
    system "#{bin}/kim-api-v2-collections-management list > ./out"
    system "grep", "ex_model_Ar_P_Morse_07C_w_Extensions", "./out"
  end
end
