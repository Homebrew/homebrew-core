class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.4.1.tar.gz"
  sha256 "89b4bd4b3bbad7402d9c81d0d9f21b679c80d0a19bb9a190e45e395736058889"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d493e80fee1f7edaf5dde4aff1b2412e2a8f2e184cc0512054a4f44d8f04bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87bbee1a60033acedb39acaff2682f4079c0e73c377a18de189e81218d5926b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9ad1aae9bcb10244a7910ac2d33dec5ca2510023ed62a491b26354d7421f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "33e26cb24a87cd2c56b147000210c37a06797f40a44261d8f419bcceb061bf19"
    sha256 cellar: :any_skip_relocation, catalina:       "0e8dc456e89957fb8d096f423b428ec42ede88eb25f90dde45f9e90baf79d72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0035464e05a6a441ecd8bbfdb9a8a69d24bef87a23d50955f11034fcd9f144de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
