class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "7053ae4681d23043daa265727dc7dbe8c65a0327d1c1bf955c29f990b39e32a7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16992923dc9e364e55dd4f17b92a52575dd8084f2fe951a80f8452eb9fe14d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0909056e6e909adfccb7443d23be2766da3158e64fb4e919aaf8598f05cf5114"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8797c0ee86155579355f77d9af135e14b9a77d25b74d6993e3b6e0932b291282"
    sha256 cellar: :any_skip_relocation, sonoma:         "123915b99ea863f969b4241ce200a9ca3b2b9048c5f391f7c506b9512d49bde4"
    sha256 cellar: :any_skip_relocation, ventura:        "4a2e2c5b56c9dc20605ec22a03bd5b68d684251534612ece4a36efa82993d780"
    sha256 cellar: :any_skip_relocation, monterey:       "752ce3925ec5b3c335b8c49c8e9f342778e7d55008bfdf0e476fef3331207392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e14b3ff84589750944cc3c44f3867ea4e913c6c8e994fa9e8f4a33459150b394"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output(bin/"flowpipe mod list 2>&1", ret_status)
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
