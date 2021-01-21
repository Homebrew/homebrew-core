class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.55.0.tar.gz"
  sha256 "7141427c5a2c3b3043f076ef7789a1a526cd8b2fa8af94d33372bd775691e141"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7364270f4ed854ac83472230a0f99b406c9e97bea23965778864829f3f7862e" => :big_sur
    sha256 "634bd6e36f69b5de8d6cdee81291ef5b205b7617b2896fb18292d60cf1c36325" => :arm64_big_sur
    sha256 "8ba22777e8cb899332d661e97616ae35c5a4a1bcb1b3175198773fbe6e9ff0cb" => :catalina
    sha256 "617faa7920513cc0d8851667f9840dabcdde844691619a14415018ef25e80208" => :mojave
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
