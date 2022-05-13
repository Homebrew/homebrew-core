class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.0/OpenCoarrays-2.10.0.tar.gz"
  sha256 "c08717aea6ed5c68057f80957188a621b9862ad0e1460470e7ec82cdd84ae798"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e30c7beae1f89eeb8fc306825122d8f4c656ff85b4df4a5186da6361cc18b73d"
    sha256 cellar: :any,                 arm64_big_sur:  "7b3607ea9feca446a7bc3ef45d34faf907d2e7d5d353f28da922fb34301f0235"
    sha256 cellar: :any,                 monterey:       "77e660ffeb752246d80daec2663a65a719b902cff7ca2224da981346792b7a10"
    sha256 cellar: :any,                 big_sur:        "a163cace42b16e61ecab6cc2e99e4767a465c7527252657c7643740af8f69502"
    sha256 cellar: :any,                 catalina:       "8e883a4a6c749eb8ea8700a11581b1027b46d89cbb48c1d07fe90ad88efec6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220cc61205d5c880912a8ef48f653543056e5362a50d983f1cfdcc1df70a28cb"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
  end
end
