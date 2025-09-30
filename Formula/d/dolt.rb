class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.59.13.tar.gz"
  sha256 "19cf7dc1025e71b8e95ee90269398cc6a67e33f96b19141be97d63245ead5803"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc68c2ea21bde4fd30c08588d77a663d1647fa44edf119bdf1e16e1a7fdffe4d"
    sha256 cellar: :any,                 arm64_sequoia: "859fc48ee8fe9303dfd0ec557f044558289f668acbded1b25e00963a9961ad90"
    sha256 cellar: :any,                 arm64_sonoma:  "8866bd6e240c4d6e5da1694ffa1e3f4840ab0580b911c6257b580f7552b91574"
    sha256 cellar: :any,                 sonoma:        "4de2665a73aaa6f23ad2f5b8872698dd498f84ce2235c81acf90e9fc154ea6b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c88322442a0e5a9ec87defaf2899b481dc62c4a5f0583f6a6ff6b8f75311e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b601d26119a20222f6b8161c3a5bfd9186acf4a352cc4ee6c827cbe94b247fb"
  end

  depends_on "go" => :build
  depends_on "icu4c@77"

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
