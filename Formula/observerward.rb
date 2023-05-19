class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.19.tar.gz"
  sha256 "936573fd7be0ebb39b0986643846f3d271b267019aaceb418b4b9dbb694118a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a1cc174608912f9cd505023b88cefd39a471cb90396fa329b36f24028b813d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7177a93544f6ac6b68a522023ec0c17c40cbb08e78ec316f23c119beaf80b095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddedaf688786edaa17a873cb6fe550cbe1892110f8e29f746d791ba8e7c17bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "dac58a2b38aefc0d94413d8ffdaa1f3ebedf5843eacd6a132c7179a663e024f8"
    sha256 cellar: :any_skip_relocation, monterey:       "99ed6b60871782f291dbc8e17c528b5c02c1c33a817b517d01e4b3d3841abd31"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3de3bf9a5630e769eb362b59b2882ef2aea895ec13c735d1e2f38acbca6d59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cbfcaa919c80057871880e57ccaeadd96ccd59dc5dc262bde86525d3b80c223"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
