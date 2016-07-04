class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.3.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.37.3.orig.tar.xz"
  sha256 "63fcb78e94e1c8cff199cada3f64c694f49c1e9fe2c3f17495dc01a5e8e03a84"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "6410d80a9c6e594570fae8772a727af5d0505dac6e7a9c477cf6f3a40e60c7dc" => :el_capitan
    sha256 "26e6a681f27128f05213b798be6de34181d85ddb44ddeed0865ff50966581dee" => :yosemite
    sha256 "a481f617d202f1ded23be932eed7ff030a73f60b3f8f8e8265f26081ccd8ecc7" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "gettext" => :optional
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
