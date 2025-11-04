class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.76.4.tar.gz"
  sha256 "23b7010a40f2d680c3ac337d5ff80c0c70dd23bd912eddda6e3135d7a93c816a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00825eedfe2f90bb7de474d8101843fe6c842241f037838c5c343cd852b6a6c7"
    sha256 cellar: :any,                 arm64_sequoia: "7ec4d0fa5f24b4eda8665f002792421c5e9b49db58030f487e5b048244ccef8b"
    sha256 cellar: :any,                 arm64_sonoma:  "00731fed723c0cc47f8497be506157490e81643dc361a7c31c321ebdb0a04865"
    sha256 cellar: :any,                 sonoma:        "e4565b798cd28fe8cdb5a219f484f27d3f9639782e3e60932d9182124c3f5967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656df62bd3b3086c9ecf52057a652a515dbf9d8f7d8487b480aa9f94d1abd88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd9a69ac66d744b23e997ad74a1ea1ff2ef4b349418ba9b92520f752f408e89"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

  def install
    ENV["CGO_ENABLED"] = "1"

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
