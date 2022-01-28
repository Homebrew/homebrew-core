class Ghp < Formula
  desc "Github Proxy | Github 代理"
  homepage "https://blog.gclmit.club"
  url "https://github.com/gclm/ghp/archive/v1.0.3.tar.gz"
  sha256 "0343680434143e1592cebee6fcb0f5053cb2127f4b3a84441b7b09ec68e9913d"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/ghp", "completion", "bash")
    (bash_completion/"ghp").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/ghp", "completion", "zsh")
    (zsh_completion/"_ghp").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/ghp", "completion", "fish")
    (fish_completion/"ghp.fish").write output
  end

  test do
    system "#{bin}/ghp", "curl", "https://raw.githubusercontent.com/gclm/homebrew-tap/note/README.md"
  end
end
