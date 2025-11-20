class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7411dbcf69122633e3ee140e76fead29abf7cd5e688a8481bfe20520965c34be"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf4ea3da53307721e7723579d2a2d7186973515dc9a6ef3e0bd45006ecc07b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4ea3da53307721e7723579d2a2d7186973515dc9a6ef3e0bd45006ecc07b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4ea3da53307721e7723579d2a2d7186973515dc9a6ef3e0bd45006ecc07b86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf4ea3da53307721e7723579d2a2d7186973515dc9a6ef3e0bd45006ecc07b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "303c0cc95a1591d6b76a1105481ac01a9ba6b3fe3cda0f3e43367cdeb7d676e2"
    sha256 cellar: :any_skip_relocation, ventura:       "0a5166424f6694bfa31c0cbd1d6804f7606a63f799eb58e5312a7784d18ef94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74448791d88ea429a8a8cb3a1996eeea11bd5e710cfa41ece5a7f0f5e87d08dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b2eb9a3004b065e3114d252a951c2648246753551e76a4e170d533052fbc7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error: unable to identify git directory for repository", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
