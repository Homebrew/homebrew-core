class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.10.tar.gz"
  sha256 "dbf525dc6b32598489ac3a0bdca904639f2f4e4d7c0de93021e308b48cab8cb2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f089752b3ee36ac7224cdfc935dcf58f7f77d5483d1d242353acb1549fbd4af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c54a5a469aec0880c919791b0f7d0f566fd42f4e74eaa681d909b0b5593e640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75904997ff407d22bc943157258b42f60c900e3ed002632966264cd3ffa366f1"
    sha256 cellar: :any_skip_relocation, ventura:        "e01dda0f845f2494efc9aa736141180235dffed227ab57ec9c1f4f805ec9b49a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a4c31809d0245932cd251f499ec312fbf258602395056f3d9b3700181d8a52b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecb81dabfc3da6060a1654abda49988c2821a91ee50b4a61aa39b119c8428dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc10ce653833effafae2469826061ae2c4f739f919199d9269eefc640d6d26f8"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
