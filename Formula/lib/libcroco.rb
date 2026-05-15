class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "https://gitlab.gnome.org/Archive/libcroco"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.13.tar.xz"
  sha256 "767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3e12a1334fe355c94acfe3f0bb286825a508b50164619031f7cd3ade763b303c"
    sha256 cellar: :any,                 arm64_sonoma:   "7b0586fbf8a45f772b65aad663dd6c6331657ede394f58bc789bf42f15c26c4e"
    sha256 cellar: :any,                 arm64_ventura:  "1936cc9609cb8de2360e762984a4a40d7c6ba2c92c6b2fd4133243a0b93426b0"
    sha256 cellar: :any,                 arm64_monterey: "0c7ea7611c087cead41eabbc6e7680a7d47c8c3fd6736d7f97742f1311f61eaf"
    sha256 cellar: :any,                 arm64_big_sur:  "d6cced1a48822aac65fbb995159f26ed0552217d125969bcae4bd61bdf223407"
    sha256 cellar: :any,                 sonoma:         "7695f1be3f909e98e882a967bb9cb770808d4c6206969f966a00c888acc05c59"
    sha256 cellar: :any,                 ventura:        "ce5d64ff6d4425936d3bd5a3f8af048edfe077b7fdb8fdf09fe0a831f1474af8"
    sha256 cellar: :any,                 monterey:       "c8404e365ec027cb735e158ea042d5c338f6d0f6594e8a7196722801059df193"
    sha256 cellar: :any,                 big_sur:        "001998f7977aa0e07aa26ab431422e56b2de76dcb7b75dee392f0d0f3674197a"
    sha256 cellar: :any,                 catalina:       "bc64de8725726ae0188ec23dc9946759565f06e45d3eb10e510d5d42d0888e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "18d8a961f813c3a2b4f52a0e06371dcc7a2344cec1461507fe00446aa7d5e05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b5c4b0de56d524a572a2bd8c93f65ed827c80093776bfd7681fd6351df6e13"
  end

  # Ref: https://gitlab.gnome.org/Archive/libcroco/-/issues/8
  deprecate! date: "2024-08-04", because: :repo_archived
  disable! date: "2025-08-04", because: :repo_archived

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-Bsymbolic", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
