class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-18.7.2/cdecl-18.7.2.tar.gz"
  sha256 "e91cc201c79456b923b45cfa779da62f5ca91824d11c545167ee7bb33a9fb810"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db165b173c52c419fc2c7f763b42e6834ac534b24fc63203c0242e386d6ef7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4018c09121a627f883e431db8b6c3af88e674945f7b268a3b489e18cb7f8b8e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff0d4d29c2a4f1d227d1253600df72b50a322a1913c791d9e17059036fe98dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a55bd22e6a8c3b3c787e0c0f3cd60d0abbe11ef199b93399d30aa1bea04753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56eddf396e6798959e9e6f408704ca917cfa00b0cca83c67063b1a27578b911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa596153a512c8d1cabffd75ab0f1ac4555dc21efe9a6e11ac4893be66074557"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "declare a as pointer to integer",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
