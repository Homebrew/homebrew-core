class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.11.tar.gz"
  sha256 "602cf73d7f7343b8c59ae82973635f5f62f26e2fe341fa990fca5fe504736384"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ac800ce5e8c8733f1196cac85cc75cfe82cd1427d0b8349affeb3a03153b321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01842f19977a4477d2c0883fe93afd2f12b9ea76fcb11125ce90607799c448cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c0bfe04867190d21ec09bd8ba714eb24ebd1c17cea13e6a36d7b048b5d693d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac38361c357ac818f40046e80d9c1d40bbfc46d58338bd42d703ce0268a8dd5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d179a2613cb6b3992b92faf7a8c5c30afd39b5a46057464c1fd1718095c38db"
    sha256 cellar: :any_skip_relocation, ventura:        "5d6bf119921ada1fcf6ebcc77d0ccc083333f87dfaf86d9acd9b447392085a24"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ba43175ec2204522560eb8deaf5d6ee460ecbca9bdea22331924e92fd43def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ac6ce4cfcedd9f918924fc199a8d4fff46017eb0a465d995cb1fa55f53deff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
