class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-18.4.2/cdecl-18.4.2.tar.gz"
  sha256 "7ab5a9241734153d7d81b29787914b3120d23fdfa5c3a2e2fdde26208a35435c"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25c9e112ed54c6205af2b721b3c7d2b7600c4d4ab5e9f830033ff0027d2bedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a737e9c4b991c2900a4a924e3435fa7df7ce14d86c690d06a6f92c9c0d6bc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cead9212974aac9593bbfaec7272e7ef26a5fdb440384886a73ca798a2e898e"
    sha256 cellar: :any_skip_relocation, sonoma:        "300d38832467679da4a92dd30c498cbf177a7c6652ab9820ed92fbc61db05178"
    sha256 cellar: :any_skip_relocation, ventura:       "105709a44e508390c8d875ed41d6c5347585e3a7208d69e1b6f765c9a185f2a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "264ace3c40f8362d9dc6a2f4b91f4d046b40dac1d225c900cf39994116b14434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7cb1131967b202a71025d739f17275b0d516be1b235e15b54489fd1c23126cd"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "declare a as pointer to integer",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
