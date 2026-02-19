class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-18.6/cdecl-18.6.tar.gz"
  sha256 "c74fe8796aafcfda53d05e11f371d3dbde82d949e5bc92883a8448d00bb69d6a"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd38e5bf4c8a8078da970660b7606ff75f23f83dd543d8326ddad49ee0d89b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac0f06d8d558fe59ada729d90ffbf7b45b4dd56f6faabeb407b86554fe32a4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19109790fb3da8fe96c85b531c408c208b519a28b72babe03142fd5629779983"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7aa224f9141bb718a4b2162815eee639b6a76e99473f14e142fa36e01dc947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841e04df30320bdd17e141f604a03081b7bd839bcb63f55b9a7771538db13beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14614c85d787397706896becc11d2148dd435f23163d90f03a199f3e7a2d8b63"
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
