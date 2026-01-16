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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9fa98c582dcb9d81e29e90d3d67aeb93e4840b39a02e7a89d46e8e6e9f6ebf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fa98c582dcb9d81e29e90d3d67aeb93e4840b39a02e7a89d46e8e6e9f6ebf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fa98c582dcb9d81e29e90d3d67aeb93e4840b39a02e7a89d46e8e6e9f6ebf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ff55281bb565da50e9811b2bb134ecb570ab3260ea65e85d522555d1846358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82047f616d9531969be3c4b0abf4d9694efae66910ee359e691c221af83e71cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfcb330a767bbcac2efc21323d2f929c1a480438e4bf8ef147909f88dcaed47"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", shell_parameter_format: :cobra)

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
