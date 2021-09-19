class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.4.tar.gz"
  sha256 "5165dc83be0ddb927ed29da594b296f958fae5182b0828f37c61c269ea7e21f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22893996b6294306fd9e0fcb6fd2563d8cb87cb0452f6690609b19b58ea415ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc06a083b4d239e3d64cdf3765add41bdcdb345ea99335df1ce152f22eb5f4b4"
    sha256 cellar: :any_skip_relocation, catalina:      "188484ad1fd092bc6c0cc18c3b5ac8bba7508ecd590860043ab34c93027aacb9"
    sha256 cellar: :any_skip_relocation, mojave:        "3800d98afd3dc25bfc6b52e96bfc4ccce678f8800158edc71c218b01076952b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9882ec21253aa12edbe535d1b7e111f84f95f77195974ba5656ac17c5117c0f"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
