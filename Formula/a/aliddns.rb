class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.23",
      revision: "0b3a93644030e1917f34ab76d4cbc279f090653c"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "06b60c6460fba278ca18d975d72e209b6e7089b35012f21dfceba3334db24b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b1a8f12757738745c93af17367461d0f6a42482075f5b31fb093bd69ada590d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90af620562ae9c772f7d5cc14f6398c498d06ea9e77cd67bc759512ab677a94f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b6ba33d055f1f0342f2aa3121593933125b2054b1fa9faae848ae71ad0d6d6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2eb96cb882b715a1d9427e5bb3f6bca9222bd24d3a2080b864632deab660582"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8051122a13e743cc9c0e6aa0eccb86ec9bcf014dff7e23180683068e19bfb75"
    sha256 cellar: :any_skip_relocation, ventura:        "f083114a10855bf586164f35d83235d74b5cd3b848adf3a7d609c26aedc4a496"
    sha256 cellar: :any_skip_relocation, monterey:       "4a87e7615baed5cb9c6e1c2b38091c93bc616a054fecc57488a43c196818cd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "04d29e980abbe4840c4a77b971d61dfa6ddc0239d72ab00de599c98d75ad5193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0adee43a8efe19657d0aec5deb3aae6bf0d54030f3fe30dd1155935dcc192e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    pkgetc.install "aliddns.yaml"
  end

  service do
    run [opt_bin/"aliddns", "-c", etc/"aliddns/aliddns.yaml"]
    keep_alive true
    log_path var/"log/aliddns.log"
    error_log_path var/"log/aliddns.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aliddns -v 2>&1")
    assert_match "config created", shell_output("#{bin}/aliddns init --config=aliddns.yml 2>&1")
    assert_path_exists testpath/"aliddns.yml"
  end
end
