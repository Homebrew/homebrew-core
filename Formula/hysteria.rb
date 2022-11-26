class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://github.com/HyNetwork/hysteria"
  url "https://github.com/HyNetwork/hysteria.git",
    tag:      "v1.3.1",
    revision: "7a7fda67f2658dd1cad777689dcfa2bda2dcdeca"
  license "MIT"
  head "https://github.com/HyNetwork/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "473c3b83bf6e681705e87a78a196a83468adde355c58962c9d0de155588a6815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333e0083b8866aa4b9803ba40dd37a86e992f75fd869c372fe31e379cba2324e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de3de5cdfe9341c61156e356f89c4d981ddaaed933e82df28ac2cfe72ac19122"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9a31387d8e782571dc1d382bf24ea4ebaaeb034a81bb173fc80720561f99c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0451607d271ec57e310851e353c5a96e7d06158ebc425b23d1150f06d1f10afe"
    sha256 cellar: :any_skip_relocation, catalina:       "77c1f7dc84f7aadffa27c02e12ad0e99acd57b46e76bc59e13812967cbb1325e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16652efa00f3cb1f1e0438335a35223acd6b6d55ea373e28eca0caddefcef22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=v#{version} -X main.appDate=#{time.rfc3339} -X main.appCommit=#{Utils.git_short_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./app/cmd"
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "listen": ":36712",
        "acme": {
          "domains": [
            "your.domain.com"
          ],
          "email": "your@email.com"
        },
        "obfs": "8ZuA2Zpqhuk8yakXvMjDqEXBwY"
      }
    EOS
    output = pipe_output "#{opt_bin}/hysteria server -c #{testpath}/config.json"
    assert_includes output, "Server configuration loaded"
  end
end
