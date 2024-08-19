class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2024.6.1.tar.gz"
  sha256 "1dff0f6af422864aa9a4e8c226282cb3f4346a4c8e661effe2571e1553603e56"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62981189e5dc48300a569d46e4715971503ccf67961cb8179d5640c79f6273e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5885f6bf3a742d7ee3c756e30d0107a9ecd25b1368458611ae5734050f9875bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ed398d05150c71293f934543a149490668cf0edd9cce9b9058d154c5255b367"
    sha256 cellar: :any_skip_relocation, sonoma:         "182870118b975e4ac4dd5f17571c8fe44563da2ff8da201c25536fcc29875e77"
    sha256 cellar: :any_skip_relocation, ventura:        "6af180ca8807842a194282a789dfbc944c40b40235fe0e80aa660d1eba75cbda"
    sha256 cellar: :any_skip_relocation, monterey:       "17d4695f522e1c15e8b56b63c7aa81abe4aab96fdad42e9b3be3fd23be668e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69bff8e769adee84a006cfcdce42471a5cc53a8548cc4ece2c712ec65d13166"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--ignore-scripts"
    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd "./build" do
        system "npm", "install", *std_npm_args
        bin.install_symlink Dir[libexec/"bin/*"]
      end
    end

    generate_completions_from_executable(
      bin/"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
