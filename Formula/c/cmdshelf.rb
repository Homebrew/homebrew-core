class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ee71c650aa2e2910bba632afb1632e00eed0d4a34968dde9f43c2728ed958b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2129cc4f853a0328aae11613e798bfae886299523422ad84bceb33b076060db7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfd2cf4bb09a17661c2b513cf67eff5fa545d549734111829c8829b105cef14"
    sha256 cellar: :any_skip_relocation, ventura:        "92038b2ba192ec3ede688f08ce352ba8502d506f02f904275c0ffeb61f08077e"
    sha256 cellar: :any_skip_relocation, monterey:       "fb958a194580d31dd505817d41030cf623f7b193a6482ee2d01fdb038b107c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b12cbcc8f895523782fc7955cd62fba746b27f76de5bc0e3b0f3c2555fd992"
    sha256 cellar: :any_skip_relocation, catalina:       "7fb831db17eb8aa4dbfd17bc4c1dee5e53dcbc1bbffa1da075c2ddba5c1df93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9125da575a5730c3dbf6e33cbaab9ad3fbb2cc361536727563306f23ba14ee01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system bin/"cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
