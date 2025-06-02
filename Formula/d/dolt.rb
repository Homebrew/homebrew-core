class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.54.1.tar.gz"
  sha256 "7380683b9086cbeb360e9fa3472bf2956440a7af4059b473af3f776d0bbee03a"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d11d767290c6ac37f92eaed582a3e5e68abb0462102d797f9ad7764717648ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "553d02c4b5ace6e443799ac645717c1c5dbc0d8ed8eae8495398c9f924f46828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1b9fe59f6d927f6d79c4103826130f73aebdbd1670516bc8ff5d8b873f53314"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb142fdab47aca3708dd3a4de702ed28de83d162fbc13e30e3cbcc737e9a151"
    sha256 cellar: :any_skip_relocation, ventura:       "8642af84d8d81fd8a6d352fb5358c4ff89eaec4d603c929495b9abe98b97e366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9dd95b67274155650a45ce3a9c594fa638c49fa918c0ebd1aa955becbcf8625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e9ff7772445bee1aa5dbf444a12d2ecd4caa2d6bc6b9eebe5c537ad5b00120"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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
