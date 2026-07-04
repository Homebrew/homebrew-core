class Odil < Formula
  desc "C++11 library for the DICOM standard"
  homepage "https://odil.readthedocs.io"
  url "https://github.com/lamyj/odil/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "0f78095600f6348cd53d9c04d1659beca5d6d01cd189a443655941229b903b5e"
  license "CECILL-B"
  head "https://github.com/lamyj/odil.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "boost"
  depends_on "dcmtk"
  depends_on "icu4c@78"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  patch do
    # remove with next release:
    url "https://github.com/lamyj/odil/commit/b9b48a231f6591bd966e1c7500d4a085f6b4620a.patch?full_index=1"
    sha256 "f15a141f4806be42e1d28e392a0154628ea005c95230e579640ee76eac68a624"
  end
  patch do
    # remove with next release:
    url "https://github.com/lamyj/odil/commit/0b72379de94b53100a8a8af9eb49e92bafce8ed7.patch?full_index=1"
    sha256 "6e4db530afb1f4d805e3c020fb39ff0bc0374bbd4a7908ea2b7417a599b545fb"
  end
  patch do
    # remove with next release:
    url "https://github.com/lamyj/odil/commit/db36ccd1686bf0e64be478930923c0880c862f21.patch?full_index=1"
    sha256 "a58c399f79d25038409f14a44239498cc82d6a8994a60555309bbac2e2bacaa7"
  end
  patch do
    # remove with next release:
    url "https://github.com/lamyj/odil/commit/3f9cc20039df9884e4d545ce30cb28f6c79da13f.patch?full_index=1"
    sha256 "b788538a77d7e22489146726bfbae3315970cd07fed389f4e359e98a95b26af1"
  end
  patch do
    # https://github.com/lamyj/odil/pull/98 https://github.com/lamyj/odil/issues/96
    url "https://github.com/ferdymercury/odil/commit/207a9237ead92486affc1b88ca5a89c0d96c679e.patch?full_index=1"
    sha256 "ece4b70f6adebd42295a4284a5b0b3429a12324854ff1be1c87781baa6f856c1"
  end
  patch do
    # https://github.com/lamyj/odil/pull/98 https://github.com/lamyj/odil/issues/96
    url "https://github.com/ferdymercury/odil/commit/ad360534e581d6de9657ffbf154a1a33bab9474e.patch?full_index=1"
    sha256 "37fa6c241ca0bdd47a244b3dc34824da9da83725e224c1b6afa7b6633851009e"
  end

  def install
    # ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("icu4c")/"pkgconfig"
    ENV.delete "PYTHONPATH"

    args = std_cmake_args
    args << "-GNinja"
    # cf. https://github.com/Homebrew/homebrew-core/issues/44093
    args << "-DBoost_NO_BOOST_CMAKE=ON"
    args << "-DCMAKE_CXX_STANDARD=17"
    args << "-DBUILD_PYTHON_WRAPPERS=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    # system bin/"odil", "--help"
    (testpath/"test.c").write <<~C
      #include "odil/uid.h"
      int main() {
          std::string const uid = odil::generate_uid();
          if (uid.size() != 64)
              return 1;
          for(auto const & c: uid)
          {
              if(!((c>='0' && c<='9') || c == '.'))
                  return 1;
          }
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lodil", "-o", "test"
    system "./test"
  end
end
