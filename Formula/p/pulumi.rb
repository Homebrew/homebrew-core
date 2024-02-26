class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.107.0",
      revision: "75f027533c96136e79a72bc26ca516a5d659282d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b98f6cc8cebe33a787efd986d37a4bedc68ee1718e3d92de3ce436bd9442b215"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea8433585b634ea1385f2a29d6b8896f33add51b9558d1b04f2aa13b432de3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bad27a90826afc2c0d74d565dae95fca7daac9385cd9a3346801aeee9754f18"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f313dfea73cf181b477a5db6df83be170d7373c3c3dc2422f9ea979c25330ca"
    sha256 cellar: :any_skip_relocation, ventura:        "2d0869fe863a497201c80c928b0accab03a0f73d2469d53e36f466375d8dd79d"
    sha256 cellar: :any_skip_relocation, monterey:       "53b34cadd58bc2308dacb30851142016ee52d4254ce9da88519e48fb8ba418eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f40ec2267eb58cd34a6a05514abb55720a1973ec0633d8e0c228ee8dea38321e"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
