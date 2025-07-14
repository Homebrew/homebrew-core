class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.7.0.tgz"
  sha256 "9d2922c230cbd7b65481fa3ea76105c0c4ef3e477a45742237aede853b63be09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ee4aa146d7d3a1add079e41820bcd47cef18d394b6b5f85407d2f70a6f301f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9ee4aa146d7d3a1add079e41820bcd47cef18d394b6b5f85407d2f70a6f301f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9ee4aa146d7d3a1add079e41820bcd47cef18d394b6b5f85407d2f70a6f301f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a60124ab8fceb2e0238e0ef5fce1e3851c6ce408b55fe764ef2c9ad900b152b"
    sha256 cellar: :any_skip_relocation, ventura:       "8a60124ab8fceb2e0238e0ef5fce1e3851c6ce408b55fe764ef2c9ad900b152b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ee4aa146d7d3a1add079e41820bcd47cef18d394b6b5f85407d2f70a6f301f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ee4aa146d7d3a1add079e41820bcd47cef18d394b6b5f85407d2f70a6f301f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
