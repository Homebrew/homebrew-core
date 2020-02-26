class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.2.tar.gz"
  sha256 "bd3ad4a5e1ff453b246462d3b57707b9d3281511b45ddda03d0d7450cf4c1fbd"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47903eeb2b4d76d81ed069ae695baece1906b69b02acc86e0e5fcd26010873df" => :catalina
    sha256 "41dadf44fd4b9615e44cab2dbc7e53cbc6382876fbd7f62bfb072b1b93f01aaa" => :mojave
    sha256 "b3c6b8ed0b9b4c245f931bd6a211040d6e6db55cbddfeea8c7f5754ecaa62e41" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
