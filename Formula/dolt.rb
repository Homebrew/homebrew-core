class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.0.0.tar.gz"
  sha256 "329d899e47375657d1aef7824574764ee54210588b6c6913362bbc6e5ff8bbbe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b72a5669757379a1e4f335abc3e1f60a448aa6bc68805eb8a20d5ddcbd8b0a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b72a5669757379a1e4f335abc3e1f60a448aa6bc68805eb8a20d5ddcbd8b0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b72a5669757379a1e4f335abc3e1f60a448aa6bc68805eb8a20d5ddcbd8b0a2"
    sha256 cellar: :any_skip_relocation, ventura:        "f24bb3725d611ed3a7f9c14eabca927949fe3c6b9d445f07f188bd5a956f0ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "f24bb3725d611ed3a7f9c14eabca927949fe3c6b9d445f07f188bd5a956f0ee3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f24bb3725d611ed3a7f9c14eabca927949fe3c6b9d445f07f188bd5a956f0ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dae94bee24d67759ff6b7a3416aab8fc7c8a0bece9c30ec54636b5fb4b0fe4a"
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
