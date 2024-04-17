class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.9.tar.gz"
  sha256 "334ae0d779c6bafa775562c93f9e6968382ee6af3b5a1dc5ff639d13bf425483"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "860d0f2a97a5783fdbcc4740692e210480d9dd373c9084c5bb626f98e7239dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5142a1ce44e6ad4a6477492ded2bdd583f7a4745f5d738a22034b7c3d67dbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1619a3d0fb887e46467d4fdba7a5809d1c4b5613d5b28cdf02faf3d7db3646eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "406503d26a84a838fbd9680109849b564090fc364d76e791f00134978500df51"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1c5be822f16d5ef77fb65c3efc5a0e5817d5db4ed39186407290451adf7bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "e13f959caad2c89f9daa7935646488f4888e4aacc64be866aec24741f928d052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75b1474c4d780661bf6f7ecbe2f77fe0cab38f9e9449b78527d06af422e9cbf"
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
