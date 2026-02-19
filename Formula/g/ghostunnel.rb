class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "264cd681f22138429dbbbf91d8dd06449c8d950880ee0d3f7bacaa48dea8bf65"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45becca36308d6735cfe0cae52faadcb5166b61fb50a0b7d8226d149cb5c155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44bbcd7285c428ee3a04e85095f322d8323fe62f77fc642efc59405c50a56564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "910a0fb459ddd59ee5a401480c71f9378017c1f47da477750e06fb4f0cece3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c719f0ff7f0b13dc8a1ba17b013bc2925887fe466fe7ee7e70ddca8bb7a3ca0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b8618771fa9e1fc65cd798ecca106c34a537caad5e1675e5d83d702abc5d87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f1f1245e8339dca2cd11817880417126f0a88c794cb01b31abccbef68f9344"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"ghostunnel", shell_parameter_format: "--completion-script-",
                                                           shells:                 [:bash, :zsh])
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
