class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.2.tar.gz"
  sha256 "352b3a65e8945d13caba92e13e5666e1854d41749aca2e230938ac6c64fa8ef9"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92919da11df9ea3afdd8b69a049a20b53281c9bd832de1ff6e283c77baf5d52f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29360b3f04fc752f44db460c7e6df38962b78204f5295d09bea1cc14ff5047cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc732468a99a346b9e37148ddd52cd9658b9f5cf23d299e0f9a6574ae03bc9a9"
    sha256 cellar: :any_skip_relocation, ventura:        "2f3918c93c0ec51ddd23af71bd055abf4169149720824c97fcbeb1a383842304"
    sha256 cellar: :any_skip_relocation, monterey:       "79d89416b7f70fbef172b48a803c6cfd86d993f7745cd474fcbd921d6576fb8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbd725be638124d51850bde8addbeff2908597b6f4031bc0a688cc7bf37c3139"
    sha256 cellar: :any_skip_relocation, catalina:       "4c471284741d327a4d7d4ea0ed131eb30f8e98a36802cb0ac85e00061df75a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075232805436d32e9c82316d0b0a1ef3fe0e93000085b54967ec02f7763eab76"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
