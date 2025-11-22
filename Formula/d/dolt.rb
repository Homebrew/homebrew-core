class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.78.2.tar.gz"
  sha256 "05e0dee48a637a7490632c4d8d9708e5450cc7bfe398dc5991eb7dbb36305643"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "571e1c76ecc65249fbe46919618eac41df8c3f4a5a80a62dea20c626306e1854"
    sha256 cellar: :any,                 arm64_sequoia: "46da0276feaa9ba5bbce8385cf445dec87a5400f24f8df2419fbaf6a7f25064e"
    sha256 cellar: :any,                 arm64_sonoma:  "22f6490616c6bb84dd57a77c805feb5037a7fb6b7002a4b01f026f456a6cc508"
    sha256 cellar: :any,                 sonoma:        "0fb62f2ddb0426e5af1f056786a4a8e441505820527c944a3e37158921336bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a2a73b8af8fd02b2262e17ce6986b7789bad15d9ea95f6c6e595e758283c347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0fc91bc71bc75ca8218c730da7609cdeae2e0d4772b39ff45a0dc41e1d3e4b"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
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
