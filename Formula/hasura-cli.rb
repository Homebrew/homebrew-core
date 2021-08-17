require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.7.tar.gz"
  sha256 "3f24e5ee3d74581de0abd35856b21959c0df38f0e80f4f1069ffb0931aa25bd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d842d936a2e6ec6a6d961255b10e19326e35c1a6f5c1956679f850c13c264312"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed042513b9d8c5374e67ae7a76dccac8e7d2f97aa60efb99d0a08bcc793a947d"
    sha256 cellar: :any_skip_relocation, catalina:      "37adbad7515ef22957b8a5e382d1ea2fe477f6ef332d16848a0e6ce784f9f697"
    sha256 cellar: :any_skip_relocation, mojave:        "37a9bec253508d37c855a853d1982fcde21af146fb804c5d552831bc842899b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8738924aaa4aebb0361afcdea706afb4dc777f658bc0e1dc373214c65b41b51c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ].join(" ")

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.arm? ? "arm64" : "amd64"
      os = "darwin"
      on_linux do
        os = "linux"
      end

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"hasura", "./cmd/hasura/"

      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "bash")
      (bash_completion/"hasura").write output
      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "zsh")
      (zsh_completion/"_hasura").write output
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
