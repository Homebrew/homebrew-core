class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.20.1.tar.gz"
  mirror "https://github.com/rjarry/aerc/archive/refs/tags/0.20.1.tar.gz"
  sha256 "fbfbf2cc4f6e251731698d6d1b7be4e88835b4e089d55e3254d37d450700db07"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "1f797aed769e542d8820ab3a1cf3f6c14683ef4f580eedce095dee79b7eaabc2"
    sha256 arm64_sonoma:  "9c0f8509ca2e627927b09ffb8690bc294d0bf45bbaa76046b26215b44160353b"
    sha256 arm64_ventura: "4397fc6735cadb6e89f0c99d5025fb66a7fcf98b7f04bd98a409bc93667df9e5"
    sha256 sonoma:        "efac3df1f65980bf5e4c70100e26f037901fbe79022afb6a6dc08168114ef035"
    sha256 ventura:       "cbe0cac33a2af190f5ed08de35b790d9d414dd57e018a3518a3cc9878395053e"
    sha256 x86_64_linux:  "b7194c18ca1bec5a8d678178dd92c06e8fbe35aa6f2902e082f2a4c1e9e0eccb"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "notmuch"

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/aerc -v")
    assert_match(/aerc #{version} \+notmuch\.*/, output)
  end
end
