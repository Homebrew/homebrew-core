class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://github.com/gammu/gammu/releases/download/1.45.0/Gammu-1.45.0.tar.gz"
  sha256 "f6ff599c79e800cb49831cb015389c453c4382263bb7a1e0b5f417acc4b75d30"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "19d2c24cc86bed64655624b67f0c240eb4ab298e1869f430d234cec310aa3369"
    sha256 arm64_tahoe:       "88dbe61a9c0f57ebe3b0220c6c2b1eb8e656b3e802c27e8c91305f80947683f9"
    sha256 arm64_sequoia:     "83bf72711d2459d3a44aa064e0fa911b47259c74d5745aef292a50705cf6a845"
    sha256 arm64_linux:       "5097099718031020f02546d2fe5daeaea8f81313bcccea52cba9a51bae39bd54"
    sha256 x86_64_linux:      "6bbcc58087a6bdc7f0df84bc214c2d9f8a1efd33b5e4e346dba10fcc7c58e84f"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
