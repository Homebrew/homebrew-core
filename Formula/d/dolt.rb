class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "b29415a5fef1ef4cc52a01e46b4b52d38a5a88f68e81cae87a0864f3e355df16"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac005b987796d97e4a18a908b15c4fc6b1b54282b41b8a354c09a3f2b9e3f82e"
    sha256 cellar: :any, arm64_sequoia: "45846e0a2b5161f8c8b55e9c6d0f4ff793fdd4977b7b13736928c284ddb672c9"
    sha256 cellar: :any, arm64_sonoma:  "dda4adac2328c0388d7537da8c13fd462a16da37b8581c3349c9f8bf38eb137c"
    sha256 cellar: :any, sonoma:        "503592698c1d43b386e6705fc372673613ff0b45ac489474c28ee8921cd5fb1f"
    sha256 cellar: :any, arm64_linux:   "1722fdb592cc69257532dc0496bb02a60870083d42070ab5577ba7ef6bd7fcab"
    sha256 cellar: :any, x86_64_linux:  "2e5410878b396e945c244f39a4d491f178b37e39cf1ceaeaca862d96e5b7d9f9"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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
