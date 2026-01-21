class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.9.2.tar.gz"
  sha256 "457383a21822a3cab1ad78f6fdfb9435bf4dc00217b018ff1b66fa4b0715d6b6"
  license "MIT"
  head "https://github.com/zeromicro/go-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^tools/goctl/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92baefb245bc91e0969717c9287bd7232dc0e462e1cb1e9aa1d73ac4fc678a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "189cc40e086e1b53c2d55ba333e64cd1635505f7685121f8e40afb7b9f8aa7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85fbf31610463cee666590d696d65e7c248c3d9c5ce2fcbddaa88b51808fd75a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e385d6f6556e5b1ab81d604dd9eeae09d155efb9648a0ce138c698f729ab05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd434282a87ae5f1cf26ed71d5bdc6a62b43f99e2112469aedcbd1d70d9e414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f49e389dc0ca241113685d8b465fd3b392601624efbcdffcd585d459a2988b"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_path_exists testpath/"api/main.tpl", "goctl install fail"
  end
end
