class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.17.0.tar.gz"
  sha256 "a8a1af36b4d4989afd670601d83fc2088e14d804c66bd1e3bdd14561bd89c2cc"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "eef77c08cf8d69afa1c59820320cd5dba759119d3b398adb44f885845ea6e32c"
    sha256 arm64_ventura:  "01ce8e648d2f1b8fb697da3a65f6e871a7233d140b03aa593df573dbdcee5fd0"
    sha256 arm64_monterey: "7e7506253ea9be9f9e691b608f67fad28e06290c134a7247f581510bc634dc2e"
    sha256 sonoma:         "8806a18b7d32f7f97257b5cedfd11dac9e7dd8eb71094263d9a8de4cdea64a99"
    sha256 ventura:        "cada196df04e28a6c58074364fd91e3cc15892b8906f44a67b6726a991901f2a"
    sha256 monterey:       "1562f08d702285efe9ba28e81e00609fef74a21aa96752b86dfb49fed60c3c8c"
    sha256 x86_64_linux:   "4c26c5c6b06cc574dcd67d8644808128c716dd042e0a000cb272e3c59d1e5826"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
