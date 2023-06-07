class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "https://ftp.gnu.org/gnu/gcal/gcal-4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcal/gcal-4.1.tar.xz"
  sha256 "91b56c40b93eee9bda27ec63e95a6316d848e3ee047b5880ed71e5e8e60f61ab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bed6280c29bc0e46bfbc4c1a3c48e2199713bfd4e51ca2f831d4a9c353d0f6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc45b8d1ab6ce7bf8b771d7745eaa1dacd95f9782966b25e8296bc8639b9e67"
    sha256 cellar: :any_skip_relocation, monterey:       "877a7f164eef12b24bca8f3fd6705becc921583fb8610af71b1372ef1dace7a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3ecf3ac091f690a0962ba9dbc1f83c2147ce8929499fcb6c24f54b3ac750476"
    sha256 cellar: :any_skip_relocation, catalina:       "4bb8c5727fb336106016d1158796e0a127fc82eb630ec9e2bccb6d70327aa531"
    sha256 cellar: :any_skip_relocation, mojave:         "39c897bb2106251109af642741220e8b92e19c52be37ef928258eb1a2f6230ff"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0a1e3ab27fcc8d08d78452074137dcdf281068c41a732a64222e9b5ed235e8fb"
    sha256 cellar: :any_skip_relocation, sierra:         "f120585bc8538eb1ab7c71ec240b150472cbf7b42e7fc6a3f008c15104d81e7c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c94d7232ff507f387fad5ba5fb0d09b1548e695cf7e1da284846a5ee828f2d03"
    sha256                               x86_64_linux:   "c50c7177f7d542efece33e069e918ecff4fcd08ae288d5b7ed9d0f232ff6daa4"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "ncurses"
  end

  def install
    # @setshortcontentsaftertitlepage was removed in Texinfo 6.3
    inreplace "doc/en/gcal.texi", "@setshortcontentsaftertitlepage\n", "" if OS.linux?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    system "make", "-C", "doc/en", "html"
    doc.install "doc/en/gcal.html"
  end

  test do
    date = Time.now.year
    assert_match date.to_s, shell_output("#{bin}/gcal")
  end
end
