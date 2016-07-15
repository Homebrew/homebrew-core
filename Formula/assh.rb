class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.4.0.tar.gz"
  sha256 "4929e2c3947b383fb86550f23528590e45b9d5166b1d001c9ef043d9e5c5fbf3"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f28a4c50038e94fc689fcadeaca613c4f39063f86c3532189a7ced70b340c07c" => :el_capitan
    sha256 "a368fc3b9cd3f7fec83533dc51a51d7379a477c0a4ee8474a811174981c19675" => :yosemite
    sha256 "bbaec90c13a3b5b6f2c8f8f3a3068e0321c2570d619c1ccfddc3a6ae912b2475" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end
