class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.52.2.tar.gz"
  sha256 "032416676d546a03ba1db8a531c4cc1d09c011595bc72816df88d2d6e32b11fe"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e521535e10213d5e283884851318018cb727f1592c6fa893011274bc175026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3b17c78ab255b4e9f1bdc3ac169b264fc9a63ea0f2b88a5935986fbea644d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42bbb22837f4e8bf65c3dd3562195c3b28a9c8efaf65a54e5c19e87b11596836"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f89bb6a5624b26a2b4f3c2e519e5ff56d9a67a00d6c0fc13a535aa99ed89985"
    sha256 cellar: :any_skip_relocation, ventura:       "3c6e0dd21d7daf475e6a82d4481841cfd2011247c5a81c2e24d9af87f2451719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87aa80b5217da06834098d8d912189404e878f2e30c99dbf9ba8a70bf12420e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38903aa1fd80545c383bf1dca88d1f588a0de667b8785a97238e487ac0410b38"
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
