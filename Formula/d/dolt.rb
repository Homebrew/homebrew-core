class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "84baa5da11944e41f89edbb4f5b695a4669a5b9f618f413d3cde3b7ddede2d3c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aff1ea9bfcb2f806757ff3bd2b2381fd9dceeee8e3dee72c518047baf154fc66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aca70f0bbe81c6f2398fd7f8af2cf1f282465f77ac4e6a2eee01975719675af7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2663bc50f9e97429e29d77b60cc6a06e8b68980e1e89042881aed1f95bb58330"
    sha256 cellar: :any_skip_relocation, sonoma:         "91165c25bd57d02aa9989015d45bd7212c4cf72a974b0e5ae27ed01867e1101a"
    sha256 cellar: :any_skip_relocation, ventura:        "10379c95dd1cc0f76a0af718c600229c8d18c49378e5bf6b24afd78a4865f9e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8c829099eebdc76e0b5541fac6076e8034df02950addbfd3f75445ae4b75747d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddf295ab0809f82e52400ad985caddbc54a022112777644b4deafac39508c94"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
