class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https://intercept.cc"
  url "https://github.com/xfhg/intercept/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "2732a3e895a9685ba6f112e7e372627aebfa340a94bf4716462b382075593308"
  license "EUPL-1.2"
  version_scheme 1
  head "https://github.com/xfhg/intercept.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4c0c35275cf063f9e3de1a2bd638ddf077db56214fc7d5473118bd48199ebce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2ca377ce1685e85a012867dbddc3a499ff32c063c29b361f653a7a4f073aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b2ca377ce1685e85a012867dbddc3a499ff32c063c29b361f653a7a4f073aa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b2ca377ce1685e85a012867dbddc3a499ff32c063c29b361f653a7a4f073aa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e28e659023400422b0e0b74efe5bfc8c1e6ba00f7a22882bc38b708997bc8a8"
    sha256 cellar: :any_skip_relocation, ventura:       "4e28e659023400422b0e0b74efe5bfc8c1e6ba00f7a22882bc38b708997bc8a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d7c1374158387acb1ddf157f471a2a50d7629b9bf11dda9d417371a333eabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d2e66df02d2438485a11a941f5c53287609a58a39aae3570e10294332688e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", "completion")

    pkgshare.install "playground"
  end

  test do
    cp_r "#{pkgshare}/playground", testpath
    cd "playground" do
      output = shell_output("#{bin}/intercept audit --policy policies/test_scan.yaml " \
                            "--target targets -vvv audit 2>&1")
      assert_match "Total Policies: 2", output
    end
  end
end
