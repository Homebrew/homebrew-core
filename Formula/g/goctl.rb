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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3e4fcdc632397c89a8edd81ee22d9a11f38f1e76fbf08dd464739cf848e8201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88141b5cc9fb90eb7b882a2fbe2792613b22b408ea6eda9ee93f9f8393db618f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ee7ae77c4a461f69e6230a040737b6848d7dbce04cb387413edc66c498eb0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e614a65e64ce7c6300a4eb782fa728979c3c458cdf93bfe5c5853e533306e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f66ee45312286459efc4da08ae5b147761296a7a666257fd1d66c2268001d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e55f9e8b01bb7698d70ee3ef544e1ce2db46779dc9190b7b6c08d24852da30"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
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
