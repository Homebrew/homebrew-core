class EndlessSky < Formula
    desc "Space trading, exploration, and combat game"
    homepage "https://github.com/endless-sky/endless-sky"
    url "https://github.com/endless-sky/endless-sky/archive/refs/tags/v0.10.12.tar.gz"
    sha256 "8082124478e4eaf1e795fc044f6e540804eded095d91fd2ff6a658c0d905f60c"
    license "GPL-3.0"
    head "https://github.com/endless-sky/endless-sky.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "ninja"
    depends_on "mad"
    depends_on "libpng"
    depends_on "sdl2"
    depends_on "jpeg_turbo"

    def install
        system "cmake", "build",
                        "cmake --preset macos" # or "macos-arm"
        system "cmake --build --preset macos-debug --target EndlessSky", "build"
    end
end
